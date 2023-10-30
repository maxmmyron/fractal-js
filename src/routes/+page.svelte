<script lang="ts">
  import { scale, mn, mx, cx, cy, exp, isTweenEnabled } from "$lib/stores";
  import { Canvas } from "@threlte/core";
  import Scene from "$lib/Scene.svelte";
  import Input from "$lib/components/Input.svelte";
  import { onMount } from "svelte";

  let container: HTMLElement;

  let resolution: number[] = [0, 0];
  let viewType: App.Locals["View"] = "mandelbrot";

  let resetScene: (type: App.Locals["View"]) => void;

  onMount(() => (resolution = [container.clientWidth, container.clientHeight]));

  const reset = () => {
    scale.set(0, { duration: 0 });
    switch (viewType) {
      case "mandelbrot":
        mn.set([-2, (-4 * (resolution[1] / resolution[0])) / 2], {
          duration: 0,
        });
        mx.set([2, (4 * (resolution[1] / resolution[0])) / 2], { duration: 0 });
        resetScene(viewType);
        break;
      case "julia":
        mn.set([-2, (-4 * (resolution[1] / resolution[0])) / 2], {
          duration: 0,
        });
        mx.set([2, (4 * (resolution[1] / resolution[0])) / 2], { duration: 0 });
        cx.set(0.285, { duration: 0 });
        cy.set(0.01, { duration: 0 });
        resetScene(viewType);
        break;
      case "burningship":
        mn.set([-2, (-3.5 * (resolution[1] / resolution[0])) / 2 + 0.5], {
          duration: 0,
        });
        mx.set([1.5, (3.5 * (resolution[1] / resolution[0])) / 2 + 0.5], {
          duration: 0,
        });
        resetScene(viewType);
      default:
        throw new Error(`Unhandled view type "${viewType}"`);
    }
  };
</script>

<main class="flex h-screen">
  <div class="w-[480px] flex flex-col gap-10 p-4 pr-2 h-full">
    <section class="flex-1 space-y-5">
      <header class="flex items-center justify-between gap-4">
        <h2 class="text-3xl font-bold">Settings</h2>
        <button
          class="px-3 py-1 border rounded-md shadow bg-slate-950 text-white"
          on:click={reset}>Reset</button
        >
      </header>
      <fieldset class="border p-3 space-y-3">
        <legend><h3 class="text-xl font-semibold">General</h3></legend>
        <div class="grid grid-cols-[2fr,4fr] gap-y-3">
          <label for="tween-transform">Tween</label>
          <input
            id="tween-transform"
            class="w-4"
            type="checkbox"
            bind:checked={$isTweenEnabled}
          />
        </div>
      </fieldset>
      <fieldset class="border p-3 space-y-3">
        <legend><h3 class="text-xl font-semibold">Render</h3></legend>
        <Input store={scale} min={0} max={100} step={0.01}>prec.</Input>
        <hr />
        <label class="w-full grid grid-cols-6">
          <span class="font-bold col-start-1">func.</span>
          <select
            bind:value={viewType}
            class="py-1 px-2 col-start-2 col-span-4"
            on:change={reset}
          >
            <option value="mandelbrot" selected>Mandelbrot Set</option>
            <option value="julia">Julia Set</option>
            <option value="burningship">Burning Ship</option>
          </select>
        </label>
        {#if viewType === "mandelbrot"}
          <Input store={exp} min={2} max={10} step={1}>exp.</Input>
        {/if}
        {#if viewType === "julia"}
          <Input store={cx} min={-2} max={2} step={0.01}>
            C<sub>x</sub>
          </Input>
          <Input store={cy} min={-2} max={2} step={0.01}>
            C<sub>y</sub>
          </Input>
        {/if}
      </fieldset>
    </section>
    <section class="space-y-5">
      <p class="mt-auto">
        made by
        <a
          class="text-neutral-500 underline font-semibold"
          href="https://mmyron.com"
        >
          max myron
        </a>
      </p>
    </section>
  </div>
  <section
    class="flex-1 m-2 rounded-lg overflow-clip shadow-md"
    bind:this={container}
  >
    <Canvas>
      <Scene {resolution} {viewType} bind:reset={resetScene} />
    </Canvas>
  </section>
</main>
