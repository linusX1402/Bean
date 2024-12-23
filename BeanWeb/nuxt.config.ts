// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },

  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },
  modules: ['@nuxt/icon'],
  icon: {
    customCollections: [
      {
        prefix: 'bean',
        dir: './assets/icons'
      }
    ]
  }
})