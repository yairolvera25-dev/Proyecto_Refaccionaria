<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DetalleProducto;
use Illuminate\Http\Request;

class DetalleProductoController extends Controller
{
    public function index()
    {
        return response()->json(DetalleProducto::all());
    }

    public function show($id)
    {
        return response()->json(DetalleProducto::findOrFail($id));
    }

    public function store(Request $request)
    {
        return response()->json(
            DetalleProducto::create($request->all()),
            201
        );
    }

    public function update(Request $request, $id)
    {
        $detalle = DetalleProducto::findOrFail($id);
        $detalle->update($request->all());

        return response()->json(['message' => 'Detalle actualizado']);
    }

    public function destroy($id)
    {
        DetalleProducto::destroy($id);

        return response()->json(['message' => 'Detalle eliminado']);
    }
}