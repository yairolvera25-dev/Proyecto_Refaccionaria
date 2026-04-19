<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Producto>
 */
class ProductoFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $precioCompra = fake()->randomFloat(2, 100, 3000);
        
        return [
            'sku' => fake()->unique()->bothify('REF-####-???'),
            'nombre' => 'Refacción ' . fake()->words(2, true),
            // Los IDs los inyectaremos desde el Seeder para no saturar la base de datos
            'id_marca' => 1, 
            'id_categoria' => 1,
            'id_proveedor' => 1,
            'precio_compra' => $precioCompra,
            'precio_venta' => $precioCompra * 1.30, 
            'stock' => fake()->numberBetween(0, 50),
        ];
    }
}
