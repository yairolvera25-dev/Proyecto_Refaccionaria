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
        $precio_compra = $this->faker->randomFloat(2, 50, 2000);
        // El precio de venta será un 30% más caro que el de compra
        $precio_venta = $precio_compra * 1.30;

        return [
            'sku' => $this->faker->unique()->bothify('REF-####??'),
            'nombre' => $this->faker->randomElement(['Amortiguador', 'Balata', 'Bujía', 'Filtro de Aceite', 'Bomba de Agua', 'Batería', 'Banda de Tiempo', 'Radiador']) . ' ' . $this->faker->word(),
            'marca' => $this->faker->randomElement(['Bosch', 'ACDelco', 'Motorcraft', 'NGK', 'Brembo', 'Castrol', 'LTH']),
            'precio_compra' => $precio_compra,
            'precio_venta' => $precio_venta,
            'stock_minimo' => $this->faker->numberBetween(5, 20),
            'foto_url' => $this->faker->imageUrl(640, 480, 'auto parts'),
            // Asignará una categoría aleatoria de las que ya existan en la base de datos
            'id_categoria' => \App\Models\Categoria::inRandomOrder()->first()->id ?? 1,
        ];
    }
}
