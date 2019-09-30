const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const devMode = process.env.NODE_ENV !== 'production';
const PurgecssPlugin = require('purgecss-webpack-plugin');
const CopyPlugin = require('copy-webpack-plugin');
const ImageminPlugin = require('imagemin-webpack-plugin').default;


class TailwindExtractor {
    static extract(content) {
        return content.match(/[A-Za-z0-9-_:\/]+/g) || [];
    }
}

module.exports = (env, options) => ({
    context: path.resolve(__dirname),
    optimization: {
        minimizer: [
            new TerserPlugin({ cache: true, parallel: true, sourceMap: devMode }),
            new OptimizeCSSAssetsPlugin({}),
            new PurgecssPlugin({
                paths: glob.sync('../lib/schtroumpsify_web/templates/**/*.html.eex'),
                extractors: [
                    {
                        extractor: TailwindExtractor,
                        extensions: ['html', 'js', 'eex'],
                    },
                ],
            }),
        ]
    },
    entry: {
        './js/app': glob.sync('./vendor/**/*.js').concat(['./js/app.js'])
    },
    output: {
        filename: '[name].js',
        path: path.resolve(__dirname, '../priv/static')
    },
    devtool: devMode ? 'source-map' : undefined,
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader'
                }
            },
            {
                test: /\.css$/,
                use: [
                    MiniCssExtractPlugin.loader,
                    {
                        loader: 'css-loader',
                        options: {
                            sourceMap: devMode
                        }
                    },
                    'postcss-loader'
                ]
            },
            {
                test: /\.(woff|woff2|eot|ttf|otf|svg)$/,
                loader: "file-loader",
                options: {
                    outputPath: "css",
                    publicPath: "../css"
                }
            }
        ]
    },
    plugins: [
        new MiniCssExtractPlugin({ filename: './css/app.css' }),
        new CopyPlugin([{ from: "./static/images", to: "images" }]),
        new ImageminPlugin({
            // disable: process.env.NODE_ENV !== 'production', // Disable during development
            pngquant: {
                quality: '45-50'
            }
        })
    ]
});
