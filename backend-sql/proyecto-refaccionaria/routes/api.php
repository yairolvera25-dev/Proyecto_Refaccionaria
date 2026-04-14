<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ProductoController;

// Ruta del CRUD
Route::apiResource('productos', ProductoController::class);

use App\Http\Controllers\SucursalController;
use App\Http\Controllers\CategoriaController;

Route::get('/sucursales', [SucursalController::class, 'index']);
Route::get('/categorias', [CategoriaController::class, 'index']);
