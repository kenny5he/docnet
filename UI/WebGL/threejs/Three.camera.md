# Threejs 相机

## [PerspectiveCamera (透视相机)](https://threejs.org/docs/#api/zh/cameras/PerspectiveCamera)
1. 构造器
    1. Api
        ```
        PerspectiveCamera( fov : Number, aspect : Number, near : Number, far : Number )
        ```
        - fov: 摄像机视锥体垂直视野角度
        - aspect: 摄像机视锥体长宽比
        - near: 摄像机视锥体近端面
        - far: 摄像机视锥体远端面
    2. 案例
    ```
    const camera = new THREE.PerspectiveCamera( 45, width / height, 1, 1000 );
    scene.add( camera );
    ``` 