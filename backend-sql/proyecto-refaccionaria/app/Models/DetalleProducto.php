<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DetalleProducto extends Model
{
    use HasFactory;

    // Obligamos a que use el nombre exacto de la base de datos
    protected $table = 'detalle_producto';
}