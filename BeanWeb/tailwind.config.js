/** @type {import('tailwindcss').Config} */
export default {
  css: ['~/assets/css/tailwind.css'],
  content: [
    './components/**/*.{js,vue,ts}',
    './layouts/**/*.vue',
    './pages/**/*.vue',
    './plugins/**/*.{js,ts}',
    './app.vue',
    './error.vue'
  ],
  theme: {
    extend: {
      fontFamily: {
        'open-sans': ['OpenSans', 'Roboto', 'sans-serif']
      },
      colors: {
        'apple-blue': '#0A5FFE',
        'apple-gray': '#A2AAAD'
      },
      fontSize: {
        'extra-large-title': '36px',
        'extra-large-title2': '28px',
        'large-title': '34px',
        'title1': '28px',
        'title2': '22px',
        'title3': '20px',
        'headline': '17px',
        'callout': '16px',
        'subheadline': '15px',
        'body': '17px',
        'footnote': '13px',
        'caption1': '12px',
        'caption2': '11px'
      }
    }
  },
  plugins: []
};

