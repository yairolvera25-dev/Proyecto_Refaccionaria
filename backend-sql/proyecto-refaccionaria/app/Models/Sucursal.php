<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Sucursal extends Model
{
    use HasFactory;

    // ¡Aquí le decimos a Laravel el nombre exacto de la tabla!
    protected $table = 'sucursales';

    protected $fillable = ['nombre_sucursal', 'ubicacion'];
}