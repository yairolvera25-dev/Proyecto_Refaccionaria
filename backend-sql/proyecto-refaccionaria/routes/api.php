<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ProductoController;

// Tu ruta del CRUD
Route::apiResource('productos', ProductoController::class);