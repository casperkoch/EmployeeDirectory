<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Position extends Model
{
    protected $fillable = [
        'title',
    ];
    
    protected $hidden = [
        'created_at',
        'updated_at',
    ];

    public function employees() {
        return $this->hasMany(Employee::class);
    }
}
