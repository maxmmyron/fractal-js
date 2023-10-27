<script lang="ts">
  import { Canvas } from "@threlte/core";
  import Scene from "$lib/Scene.svelte";

  let canvas: HTMLCanvasElement;
</script>

<h1>
  Me when I draw the set of all points in the complex plane that do not diverse
  when recursively applied to the function f(z)=z<sup>2</sup>+c (with z starting
  at 0 and c being some point on the complex plane.)
</h1>
<main>
  <Canvas>
    <Scene />
  </Canvas>
</main>

<style>
  main {
    width: 100%;
    aspect-ratio: 16/10;
    max-height: 90vh;
  }
</style>
