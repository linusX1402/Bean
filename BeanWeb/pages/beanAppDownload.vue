<script lang="ts" setup>
import BeanLogo from '~/components/beanLogo.vue';

function downloadApp() {
  console.log('downloaded app');
}
</script>

<template>
  <div class="flex pl-8 pb-5 pt-14 pr-4 gap-10">
    <bean-logo />
    <div class="flex justify-between flex-col">
      <div>
        <h2 class="font-bold">Bean</h2>
        <p class="text-black/50 font-semibold">
          Track your Beans easily
        </p>
      </div>
      <button class="font-semibold w-fit text-white bg-apple-blue rounded-full px-6 py-2" @click="downloadApp">
        Get
      </button>
    </div>
  </div>
  <div class="w-screen h-[1px] bg-apple-gray mb-16" />
  <div class="flex gap-10 overflow-x-scroll pl-10 pr-32 h-full snap-x">
    <img alt="App Preview" class="rounded-3xl border-solid border border-apple-gray h-[60vh] mb-10 snap-center"
         src="../assets/images/prev-1.png">
    <img alt="App Preview" class="rounded-3xl border-solid border border-apple-gray h-[60vh] mb-10 snap-center"
         src="../assets/images/prev-2.png">
    <img alt="App Preview" class="rounded-3xl border-solid border border-apple-gray h-[60vh] mb-10 snap-center"
         src="../assets/images/prev-3.png">
  </div>

</template>

<style scoped>

</style>