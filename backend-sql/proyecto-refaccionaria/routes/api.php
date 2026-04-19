<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
 
use App\Http\Controllers\Api\ProductoController;


Route::post('/productos/descontar-stock', [ProductoController::class, 'descontarStock']);

// PRIMERO las rutas específicas
Route::get('/productos/bajo-stock', [ProductoController::class, 'bajoStock']);


// Esta sola línea crea rutas para: Listar, Crear, Ver uno, Actualizar y Borrar
Route::apiResource('productos', ProductoController::class);