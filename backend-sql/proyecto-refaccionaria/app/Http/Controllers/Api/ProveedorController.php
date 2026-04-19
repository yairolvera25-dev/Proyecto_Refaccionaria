<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Proveedor;
use Illuminate\Http\Request;

class ProveedorController extends Controller
{
    public function index()
    {
        return response()->json(Proveedor::all());
    }

    public function show($id)
    {
        return response()->json(Proveedor::findOrFail($id));
    }

    public function store(Request $request)
    {
        return response()->json(Proveedor::create($request->all()));
    }

    public function update(Request $request, $id)
    {
        $proveedor = Proveedor::findOrFail($id);
        $proveedor->update($request->all());

        return response()->json(['message' => 'Proveedor actualizado']);
    }

    public function destroy($id)
    {
        Proveedor::destroy($id);
        return response()->json(['message' => 'Proveedor eliminado']);
    }
}