<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Producto;
use Illuminate\Http\Request;

class ProductoController extends Controller
{
    public function index()
    {
        // Traemos los productos incluyendo su marca y categoria
        $productos = Producto::with(['marca', 'categoria'])->get();
        
        return response()->json($productos, 200);
    }
}
