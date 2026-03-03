<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Producto extends Model
{
    use HasFactory;

    protected $fillable = [
        'sku',
        'nombre',
        'marca',
        'precio_compra',
        'precio_venta',
        'stock_minimo',
        'foto_url',
        'id_categoria'
    ];
}