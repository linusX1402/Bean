<script lang="js" setup>
import BeanLogo from '~/components/beanLogo.vue';

function downloadApp() {}
</script>

<template>
    <div class="flex gap-10 pb-5 pl-8 pr-4 pt-14">
        <bean-logo />
        <div class="flex flex-col justify-between">
            <div>
                <h2 class="font-bold">Bean</h2>
                <p class="font-medium text-black/50">Track your Beans easily</p>
            </div>
            <a
                class="w-fit rounded-full bg-apple-blue px-6 py-2 font-semibold text-white"
                download=""
                href="/bean-light.png"
            >
                Get
            </a>
        </div>
    </div>
    <div class="mb-16 h-[1px] w-screen bg-apple-gray" />
    <section class="flex h-full snap-x gap-10 overflow-x-scroll pl-10 pr-32">
        <img
            alt="some alt text"
            class="mb-10 max-h-[90vh] snap-center rounded-3xl border border-solid border-apple-gray sm:max-h-[80vh] 2xl:max-h-[70vh]"
            src="../public/images-desc/prev-1.png"
        />
        <img
            alt="some alt text"
            class="mb-10 max-h-[90vh] snap-center rounded-3xl border border-solid border-apple-gray sm:max-h-[80vh] 2xl:max-h-[70vh]"
            src="../public/images-desc/prev-2.png"
        />
        <img
            alt="App Preview"
            class="mb-10 max-h-[90vh] snap-center rounded-3xl border border-solid border-apple-gray sm:max-h-[80vh] 2xl:max-h-[70vh]"
            src="../assets/images/prev-3.png"
        />
    </section>
</template>

<style scoped></style>
