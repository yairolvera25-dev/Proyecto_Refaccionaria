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

    public function bajoStock()
    {
        try {
            // Buscamos productos donde la columna 'stock' sea menor o igual a 10
            // y nos traemos su marca y categoría para que Vue no llore
            $productos = Producto::with(['marca', 'categoria'])
                ->where('stock', '<=', 10)
                ->get();

            return response()->json([
                'exito' => true,
                'data' => $productos
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'exito' => false,
                'message' => 'Error en el servidor: ' . $e->getMessage()
            ], 500);
        }
    }

    public function descontarStock(Request $request)
    {
        try {
            $items = $request->items; // Recibimos el arreglo de productos vendidos
            
            foreach ($items as $item) {
                $producto = Producto::find($item['id']);
                if ($producto) {
                    // Le restamos la cantidad vendida a lo que hay en bodega
                    $producto->stock = $producto->stock - $item['cantidad'];
                    $producto->save();
                }
            }

            return response()->json([
                'exito' => true, 
                'message' => 'Inventario actualizado correctamente'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'exito' => false, 
                'message' => 'Error al descontar stock: ' . $e->getMessage()
            ], 500);
        }
    }
}
