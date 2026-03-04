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
        // 1. Creamos 8 categorías primero (para que los productos tengan a dónde asignarse)
        Categoria::factory(8)->create();

        // 2. Creamos 3 sucursales
        Sucursal::factory(3)->create();

        // 3. Creamos 200 productos
        Producto::factory(200)->create();
    }
}
