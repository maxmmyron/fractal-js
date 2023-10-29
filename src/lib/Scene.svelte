<script lang="ts">
  import { scale, mn, mx, cx, cy, view } from "$lib/stores";
  import vertexShader from "$lib/shaders/vertex.glsl?raw";
  import fragmentShader from "$lib/shaders/fragment.glsl?raw";
  import { T } from "@threlte/core";
  import { interactivity } from "@threlte/extras";

  export let resolution: number[];

  // i don't really understand why 7.68 fits the plane to the screen ¯\_(ツ)_/¯
  const planeScaling = 7.68;

  let xmin = -2;
  let xmax = 1;

  let yRange = (xmax - xmin) * (1 / 1.6);

  let ymin = -yRange / 2;
  let ymax = yRange / 2;

  const normalize = (
    value: number,
    localmin: number,
    localmax: number,
    min: number,
    max: number
  ) => {
    let norm = (value - localmin) / (localmax - localmin);
    return norm * (max - min) + min;
  };

  interactivity();
  const zoom = (
    e: unknown & { point: { x: number; y: number; z: number } }
  ) => {
    // given scale, x, and y, calculate the new scale, x, and y.
    // x and y is the current center of the screen.
    // scale is the current zoom level, expressed at pow(1.5, scale).

    // get the current mouse position
    const { point } = e;

    console.log(`mouse position: (${point.x}, ${point.y})`);
    console.log(`prev zoom -- x: (${xmin}, ${xmax}), y: (${ymin}, ${ymax})`);

    const width = 1.6 * planeScaling;
    const height = planeScaling;

    const wmin = -width / 2;
    const wmax = width / 2;

    const hmin = -height / 2;
    const hmax = height / 2;

    let normedXMin = normalize(point.x + wmin, wmin, wmax, xmin, xmax);
    let normedYMin = normalize(point.y + hmin, hmin, hmax, ymin, ymax);

    let normedXMax = normalize(point.x + wmax, wmin, wmax, xmin, xmax);
    let normedYMax = normalize(point.y + hmax, hmin, hmax, ymin, ymax);

    // set the new values
    scale.set($scale + 1);

    console.log(
      `new zoom -- x: (${normedXMin}, ${normedXMax}), y: (${normedYMin}, ${normedYMax})`
    );

    xmin = normedXMin;
    ymin = normedYMin;
    xmax = normedXMax;
    ymax = normedYMax;

    mn.set([normedXMin, normedYMin], { duration: 0 });
    mx.set([normedXMax, normedYMax], { duration: 0 });
  };
</script>

<T.Mesh on:click={zoom}>
  <T.PlaneGeometry args={[1.6 * planeScaling, planeScaling]} />
  <T.ShaderMaterial
    {vertexShader}
    {fragmentShader}
    uniforms={{
      resolution: { value: resolution },
      scale: { value: 0.0 },
      mn: { value: [-2, -1] },
      mx: { value: [1, 1] },
      juliaC: { value: [0.0, 0.0] },
      view: { value: 0 },
    }}
    uniforms.scale.value={$scale}
    uniforms.mn.value={$mn}
    uniforms.mx.value={$mx}
    uniforms.juliaC.value={[$cx, $cy]}
    uniforms.view.value={$view}
  />
</T.Mesh>
