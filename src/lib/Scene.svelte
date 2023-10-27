<script>
  import { vertex, fragment } from "$lib/shaders/shader";
  import { T } from "@threlte/core";

  // i don't really understand why 7.68 fits the plane to the screen ¯\_(ツ)_/¯
  let scale = 7.68;
</script>

<T.Mesh>
  <T.PlaneGeometry args={[1.6 * scale, scale]} />
  <T.ShaderMaterial
    vertexShader={vertex}
    fragmentShader={fragment}
    uniforms={{
      resolution: { value: [window.innerWidth, window.innerHeight] },
    }}
  />
</T.Mesh>
