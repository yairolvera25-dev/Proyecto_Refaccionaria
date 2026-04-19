<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DetalleProducto extends Model
{
    use HasFactory;

    protected $table = 'detalle_producto';

    protected $fillable = [
        'id_producto',
        'material',
        'meses_garantia',
        'estado_producto'
    ];

    public function producto()
    {
        return $this->belongsTo(Producto::class, 'id_producto');
    }
}