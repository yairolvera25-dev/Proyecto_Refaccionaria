<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Crear categorías
        $categorias = \App\Models\Categoria::factory(10)->create();

        // Crear marcas
        $marcas = \App\Models\Marca::factory(15)->create();

        // Crear proveedores
        $proveedores = \App\Models\Proveedor::factory(5)->create();

        // Crear productos
        \App\Models\Producto::factory(200)->make()->each(function ($producto) use ($categorias, $marcas, $proveedores) {
            $producto->id_categoria = $categorias->random()->id;
            $producto->id_marca = $marcas->random()->id;
            $producto->id_proveedor = $proveedores->random()->id;
            $producto->save();

            // Crear detalle del producto relacionado
            \App\Models\DetalleProducto::factory()->create([
                'id_producto' => $producto->id
            ]);
        });
    }
}