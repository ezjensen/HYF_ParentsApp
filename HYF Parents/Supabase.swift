//
//  Supabase.swift
//  HYF Parents
//
//  Created by Eric Jensen on 8/11/25.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
	supabaseURL: URL(string: "https://dnnkzeghqckuqinlamps.supabase.co")!,
	supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRubmt6ZWdocWNrdXFpbmxhbXBzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1Nzk4NTcsImV4cCI6MjA3MDE1NTg1N30.upNLACkKXkwZ4nfubPpBEI0YiTWxUCbQ-0rW--pAbrE"
)
