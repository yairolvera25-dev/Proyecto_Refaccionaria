<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\DetalleProducto>
 */
class DetalleProductoFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'id_producto' => 1, // Se inyectará desde el Seeder
            'material' => fake()->randomElement(['Acero', 'Aluminio', 'Plástico', 'Goma', 'Cerámica']),
            'meses_garantia' => fake()->randomElement([3, 6, 12, 24]),
            'estado_producto' => fake()->randomElement(['Nuevo', 'Usado']),
        ];
    }
}
