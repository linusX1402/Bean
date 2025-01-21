<script lang="ts" setup>
import BeanLogo from '~/components/beanLogo.vue';

function downloadApp() {

}
</script>

<template>
  <div class="flex pl-8 pb-5 pt-14 pr-4 gap-10">
    <bean-logo />
    <div class="flex justify-between flex-col">
      <div>
        <h2 class="font-bold">Bean</h2>
        <p class="text-black/50 font-medium">
          Track your Beans easily
        </p>
      </div>
      <a class="font-semibold w-fit text-white bg-apple-blue rounded-full px-6 py-2" href="/bean-light.png" download="">
        Get
      </a>
    </div>
  </div>
  <div class="w-screen h-[1px] bg-apple-gray mb-16" />
  <section class="flex gap-10 overflow-x-scroll pl-10 pr-32 h-full snap-x">
    <img alt="App Preview" class="rounded-3xl border-solid border border-apple-gray max-h-[90vh] sm:max-h-[80vh] 2xl:max-h-[70vh] mb-10 snap-center"
         src="../assets/images/prev-1.png">
    <img alt="App Preview" class="rounded-3xl border-solid border border-apple-gray max-h-[90vh] sm:max-h-[80vh] 2xl:max-h-[70vh] mb-10 snap-center"
         src="../assets/images/prev-2.png">
    <img alt="App Preview" class="rounded-3xl border-solid border border-apple-gray max-h-[90vh] sm:max-h-[80vh] 2xl:max-h-[70vh] mb-10 snap-center"
         src="../assets/images/prev-3.png">
  </section>

</template>

<style scoped>

</style>