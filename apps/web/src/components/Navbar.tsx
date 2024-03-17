"use client";

import { useState } from "react";

import Image from "next/image";
import Link from "next/link";
import { AppBar } from "@mui/material";

export function Navbar() {

  // Render Navbar
  return (
    <AppBar
      position="sticky"
      className={`text-gray-900 bg-white px-4 py-4 shadow-lg lg:px-12`}
    >
      <div className="container mx-auto flex items-center justify-between">
        <div className="flex items-center gap-6">
          <Image
            src="/pawpoint.png"
            alt="Pawpoint Logo"
            width={100}
            height={50}
          />
          <h1 className="text-2xl font-bold">Pawpoint</h1>
        </div>
        <ul
          className={`ml-10 hidden items-center gap-6 lg:flex ${
            "text-gray-900" 
          }`}
        >
          <Link href="/" >
            About
          </Link>
          <Link href="/map" >
            Map
          </Link>
          <Link href="/collections" >
            My Collection
          </Link>
          <Link href="/store" >
            Store
          </Link>
          <Link href="/auth" className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
            Login / Sign up
          </Link>
        </ul>
      </div>
    </AppBar>
  );
}

export default Navbar;
