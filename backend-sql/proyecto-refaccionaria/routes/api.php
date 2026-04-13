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
Route::post('productos/descontar-stock', [ProductoController::class, 'descontarStock']);

