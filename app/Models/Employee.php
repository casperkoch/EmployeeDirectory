<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Employee extends Model
{
    use HasFactory;

    protected $casts = [
        'phone' => 'integer',
    ];

    protected $fillable = [
        'name',
        'email',
        'phone',
        'position_id',
    ];

    protected $hidden = [
        'created_at',
        'updated_at',
    ];    

    public function position() {
        return $this->belongsTo(Position::class);
    }
}
