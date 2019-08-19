function requireAll(require) {
    require.keys().forEach(require);
}
requireAll(require.context('../lib/schtroumpsify_web/templates/', true, /\.eex/));