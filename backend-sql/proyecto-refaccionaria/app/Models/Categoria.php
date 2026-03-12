<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory; // <- 1. Importamos esta línea
use Illuminate\Database\Eloquent\Model;

class Categoria extends Model
{
    use HasFactory; // <- 2. La declaramos dentro de la clase

    // De una vez protegemos los campos para el CRUD
    protected $fillable = ['nombre', 'descripcion'];
}