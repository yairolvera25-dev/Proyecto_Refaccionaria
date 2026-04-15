<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Producto;
use Illuminate\Http\Request;

class ProductoController extends Controller
{
    // --- MÉTODOS PARA EL DASHBOARD (VUE) ---

    // 1. Corregimos el index para que "stock_minimo" aparezca como "stock"
    public function index()
    {
        // Usamos select para renombrar la columna y que el Frontend no se rompa
        $productos = Producto::select('*', 'stock_minimo as stock')->get();
        return response()->json($productos, 200);
    }

    // 2. Corregimos la búsqueda (tenías stock_minimo mapeado, pero faltaba en el index)
    public function buscar(Request $request)
    {
        $q = $request->query('q');
        if (!$q) return response()->json([]);

        $productos = Producto::where('nombre', 'LIKE', "%{$q}%")
            ->orWhere('sku', 'LIKE', "%{$q}%")
            ->orWhere('marca', 'LIKE', "%{$q}%")
            ->take(15)
            ->get();

        $resultado = $productos->map(function ($p) {
            return [
                'id' => $p->id,
                'nombre' => $p->nombre . " (" . $p->marca . ")",
                'sku' => $p->sku,
                'precio' => (float) $p->precio_venta,
                'stock' => (int) $p->stock_minimo // Aseguramos que sea entero
            ];
        });

        return response()->json($resultado);
    }

    public function bajoStock()
    {
        // 1. Traemos TODOS los productos unidos con su inventario (sin filtros SQL que se rompan)
        $productos = Producto::join('inventario_sucursal', 'productos.id', '=', 'inventario_sucursal.id_producto')
            ->select('productos.*', 'inventario_sucursal.cantidad')
            ->get();

        // 2. Usamos PHP puro para filtrar la lista. ¡Esto no falla!
        $criticos = $productos->filter(function ($prod) {
            // Si el stock_minimo es nulo, vacío, o cero, le asignamos 5 por defecto.
            $minimo = !empty($prod->stock_minimo) ? $prod->stock_minimo : 5;
            
            // ¿La cantidad en bodega es menor o igual al mínimo permitido?
            return $prod->cantidad <= $minimo;
        })->values(); // values() reordena el arreglo para que Vue lo lea bien

        // 3. Enviamos solo los que no pasaron la prueba
        return response()->json($criticos);
    }

    public function descontarStock(Request $request)
    {
        $items = $request->input('items');

        if (!$items || !is_array($items)) {
            return response()->json(['error' => 'No se enviaron items válidos'], 400);
        }

        try {
            \Illuminate\Support\Facades\DB::beginTransaction();

            foreach ($items as $item) {
                // Bloqueamos la fila (Pessimistic Locking) mientras hacemos el update
                // para evitar colisiones si dos vendedores venden el mismo producto 
                // al mismo milisegundo.
                $producto = Producto::lockForUpdate()->find($item['id']);
                
                if (!$producto) {
                    throw new \Exception("Producto con ID {$item['id']} no encontrado.");
                }
                
                // NOTA: Si en el futuro cambias a inventario_sucursal, este es el lugar.
                $producto->stock_minimo = $producto->stock_minimo - $item['cantidad'];
                $producto->save();
            }

            \Illuminate\Support\Facades\DB::commit();

            return response()->json(['mensaje' => 'Stock descontado masivamente con éxito en MySQL']);

        } catch (\Exception $e) {
            \Illuminate\Support\Facades\DB::rollBack();
            return response()->json([
                'error' => 'La transacción falló, todo el lote fue revertido.',
                'detalle' => $e->getMessage()
            ], 500);
        }
    }

    // --- MÉTODOS CRUD ORIGINALES ---

    public function store(Request $request)
    {
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

    public function show($id)
    {
        $producto = Producto::find($id);
        if (!$producto) {
            return response()->json(['mensaje' => 'Producto no encontrado'], 404);
        }
        return response()->json($producto, 200);
    }

    public function update(Request $request, $id)
    {
        $producto = Producto::find($id);
        if (!$producto) {
            return response()->json(['mensaje' => 'Producto no encontrado'], 404);
        }

        $producto->update($request->all());
        return response()->json(['mensaje' => 'Producto actualizado', 'data' => $producto], 200);
    }

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