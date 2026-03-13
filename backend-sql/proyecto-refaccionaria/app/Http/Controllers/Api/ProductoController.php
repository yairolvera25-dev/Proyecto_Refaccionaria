<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Producto;
use Illuminate\Http\Request;

class ProductoController extends Controller
{
    // 1. LEER (Obtener todos los productos)
    public function index()
    {
        // Traemos los productos y de paso incluimos los datos de su categoría
        return response()->json(Producto::all(), 200);
    }

    // 2. CREAR (Guardar un producto nuevo)
    public function store(Request $request)
    {
        // Validamos que no falten datos (Como lo pide tu tarjeta)
        $request->validate([
            'sku' => 'required|unique:productos',
            'nombre' => 'required|string',
            'marca' => 'required|string',
            'precio_compra' => 'required|numeric',
            'precio_venta' => 'required|numeric',
            'stock_minimo' => 'required|integer',
            'id_categoria' => 'required|exists:categorias,id'
        ]);

        $producto = Producto::create($request->all());
        return response()->json(['mensaje' => 'Producto creado con éxito', 'data' => $producto], 201);
    }

    // 3. LEER UNO (Ver el detalle de un solo producto)
    public function show($id)
    {
        $producto = Producto::find($id);
        if (!$producto) {
            return response()->json(['mensaje' => 'Producto no encontrado'], 404);
        }
        return response()->json($producto, 200);
    }

    // 4. ACTUALIZAR (Editar un producto existente)
    public function update(Request $request, $id)
    {
        $producto = Producto::find($id);
        if (!$producto) {
            return response()->json(['mensaje' => 'Producto no encontrado'], 404);
        }

        $producto->update($request->all());
        return response()->json(['mensaje' => 'Producto actualizado', 'data' => $producto], 200);
    }

    // 5. BORRAR (Eliminar una refacción)
    public function destroy($id)
    {
        $producto = Producto::find($id);
        if (!$producto) {
            return response()->json(['mensaje' => 'Producto no encontrado'], 404);
        }

        $producto->delete();
        return response()->json(['mensaje' => 'Producto eliminado correctamente'], 200);
    }
}

