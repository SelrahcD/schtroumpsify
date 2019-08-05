const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const devMode = process.env.NODE_ENV !== 'production'
const PurgecssPlugin = require('purgecss-webpack-plugin');

// Custom PurgeCSS extractor for Tailwind that allows special characters in
// class names.
// https://github.com/FullHuman/purgecss#extractor
class TailwindExtractor {
    static extract(content) {
        return content.match(/[A-Za-z0-9-_:\/]+/g) || [];
    }
}

module.exports = (env, options) => ({
    optimization: {
        minimizer: [
            new TerserPlugin({ cache: true, parallel: true, sourceMap: devMode }),
            new OptimizeCSSAssetsPlugin({}),
            new PurgecssPlugin({
                    paths: glob.sync('../lib/<YOUR_APP_NAME>_web/templates/**/*.html.eex'),
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
        './js/app.js': glob.sync('./vendor/**/*.js').concat(['./js/app.js'])
    },
    output: {
        filename: 'app.js',
        path: path.resolve(__dirname, '../priv/static/js')
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
            }
        ]
    },
    plugins: [
        new MiniCssExtractPlugin({ filename: '../css/app.css' }),
        new CopyWebpackPlugin([{ from: 'static/', to: '../' }])
    ]
});
