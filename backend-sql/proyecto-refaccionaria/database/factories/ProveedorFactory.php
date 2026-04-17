<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Proveedor>
 */
class ProveedorFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'nombre_empresa' => fake()->unique()->company() . ' Autopartes',
            'contacto' => fake()->name(),
            'telefono' => fake()->numerify('##########'),
            'email' => fake()->unique()->companyEmail(),
    ];
}
}
