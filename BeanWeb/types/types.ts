export {};
declare global {
    type bImage = {
        src: string;
        alt: string;
    };
    type bApiImage = {
        images: bImage[];
    };
}
