<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;


class SucursalFactory extends Factory
{

    public function definition(): array
    {
        return [
            'nombre_sucursal' => 'Sucursal ' . $this->faker->unique()->city(),
            'ubicacion' => $this->faker->address(),
        ];
    }
}
