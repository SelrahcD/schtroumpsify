module.exports = {
  theme: {
      fontFamily: {
          body: ['Lato', 'sans-serif']
      },
    extend: {
        colors: {
            'schtroumpf-blue': {
                100: '#EDF9FE',
                200: '#D2EFFC',
                300: '#B7E6FA',
                400: '#80D3F6',
                500: '#4AC0F2',
                600: '#43ADDA',
                700: '#2C7391',
                800: '#21566D',
                900: '#163A49',
            }
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
