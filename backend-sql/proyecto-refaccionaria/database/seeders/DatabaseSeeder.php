<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Categoria;
use App\Models\Sucursal;
use App\Models\Producto;

class DatabaseSeeder extends Seeder
{
    public function run(): void
{
    // 1. Creamos 10 categorías
    $categorias = \App\Models\Categoria::factory(10)->create();

    // 15 marcas
    $marcas = \App\Models\Marca::factory(15)->create();
    
    // 5 proveedores
    $proveedores = \App\Models\Proveedor::factory(5)->create();

    // 2. Creamos los 200 Productos de tu HU-02
    \App\Models\Producto::factory(200)->make()->each(function ($producto) use ($categorias, $marcas, $proveedores) {
        
        // Le asignamos IDs aleatorios de los que creamos arriba
        $producto->id_categoria = $categorias->random()->id;
        $producto->id_marca = $marcas->random()->id;
        $producto->id_proveedor = $proveedores->random()->id;
        $producto->save();

        // 3. Le creamos su detalle a cada producto pero lo forzamos a que su llave foránea id_producto sea exactamente igual al ID del producto que acabamos de guardar
        \App\Models\DetalleProducto::factory()->create([
            'id_producto' => $producto->id
        ]);
    });
}
}
