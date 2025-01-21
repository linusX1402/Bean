// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  css: ['~/assets/css/tailwind.css'],
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },

  typescript: {
    typeCheck: true,
  },

  modules: ['@nuxt/icon'],
  icon: {
    customCollections: [
      {
        prefix: 'bean.txt',
        dir: './assets/icons'
      }
    ]
  }
})