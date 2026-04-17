<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Producto extends Model
{
    
    // Esto permite que podamos guardar datos masivamente
    protected $fillable = ['nombre', 'descripcion', 'precio', 'stock', 'id_marca', 'id_categoria'];

    public function marca() {
        return $this->belongsTo(Marca::class, 'id_marca');
    }

    public function categoria() {
        return $this->belongsTo(Categoria::class, 'id_categoria');
    }
}