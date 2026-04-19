<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Producto;
use Illuminate\Http\Request;

class ProductoController extends Controller
{
    public function index()
    {
        return response()->json(Producto::all(), 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'sku' => 'required|string|max:255|unique:productos,sku',
            'nombre' => 'required|string|max:255',
            'marca_id' => 'required|exists:marcas,id',
            'categoria_id' => 'required|exists:categorias,id',
            'proveedor_id' => 'required|exists:proveedores,id',
            'precio_compra' => 'required|numeric',
            'precio_venta' => 'required|numeric',
            'stock' => 'required|integer'
        ]);

        $producto = Producto::create([
            'sku' => $request->sku,
            'nombre' => $request->nombre,
            'id_marca' => $request->marca_id,
            'id_categoria' => $request->categoria_id,
            'id_proveedor' => $request->proveedor_id,
            'precio_compra' => $request->precio_compra,
            'precio_venta' => $request->precio_venta,
            'stock' => $request->stock
        ]);

        return response()->json($producto, 201);
    }

    public function update(Request $request, $id)
    {
        $producto = Producto::findOrFail($id);

        $request->validate([
            'sku' => 'required|string|max:255|unique:productos,sku,' . $id,
            'nombre' => 'required|string|max:255',
            'marca_id' => 'required|exists:marcas,id',
            'categoria_id' => 'required|exists:categorias,id',
            'proveedor_id' => 'required|exists:proveedores,id',
            'precio_compra' => 'required|numeric',
            'precio_venta' => 'required|numeric',
            'stock' => 'required|integer'
        ]);

        $producto->update([
            'sku' => $request->sku,
            'nombre' => $request->nombre,
            'id_marca' => $request->marca_id,
            'id_categoria' => $request->categoria_id,
            'id_proveedor' => $request->proveedor_id,
            'precio_compra' => $request->precio_compra,
            'precio_venta' => $request->precio_venta,
            'stock' => $request->stock
        ]);

        return response()->json($producto, 200);
    }

    public function destroy($id)
    {
        $producto = Producto::findOrFail($id);
        $producto->delete();

        return response()->json(['msg' => 'Eliminado'], 200);
    }

    public function bajoStock()
    {
        $productos = Producto::where('stock', '<=', 5)->get();
        return response()->json($productos, 200);
    }

    public function descontarStock(Request $request)
    {
        $request->validate([
            'id' => 'required|exists:productos,id',
            'cantidad' => 'required|integer|min:1'
        ]);

        $producto = Producto::findOrFail($request->id);

        if ($producto->stock < $request->cantidad) {
            return response()->json(['msg' => 'Stock insuficiente'], 400);
        }

        $producto->stock = $producto->stock - $request->cantidad;
        $producto->save();

        return response()->json($producto, 200);
    }
}