<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Producto;
use Illuminate\Http\Request;

class ProductoController extends Controller
{
    public function index()
    {
        $productos = Producto::with(['marca', 'categoria', 'proveedor', 'detalle'])->get();

        return response()->json($productos, 200);
    }

    public function bajoStock()
    {
        try {
            $productos = Producto::with(['marca', 'categoria', 'proveedor', 'detalle'])
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
            $items = $request->items;

            foreach ($items as $item) {
                $producto = Producto::find($item['id']);

                if ($producto) {
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