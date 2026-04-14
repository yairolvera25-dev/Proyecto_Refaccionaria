<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ProductoController;

// 1. Rutas de Especialidad (Deben ir ARRIBA del resource)
Route::get('productos/buscar', [ProductoController::class, 'buscar']);
Route::get('productos/bajo-stock', [ProductoController::class, 'bajoStock']);

// 2. Ruta del CRUD estándar
Route::apiResource('productos', ProductoController::class);

// Agrégalo junto a tus otras rutas personalizadas
Route::patch('productos/descontar', [ProductoController::class, 'descontarStock']);

use App\Http\Controllers\SucursalController;
use App\Http\Controllers\CategoriaController;

Route::get('/sucursales', [SucursalController::class, 'index']);
Route::get('/categorias', [CategoriaController::class, 'index']);
