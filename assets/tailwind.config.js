module.exports = {
  theme: {
      fontFamily: {
          body: ['Lato', 'sans-serif']
      },
    extend: {
        colors: {
            'schtroumpf-blue-600': '#4ac0f2',
            'schtroumpf-blue-700': '#1197d4',
        },
    }
  },
    variants: {
        borderWidth: ['responsive', 'last', 'first'],
        borderColor: ['responsive', 'last', 'first'],
        padding: ['responsive'],
    },
  plugins: []
}
