import React from 'react'
import Head from 'next/head'
import SideMenu from './SideMenu'

type Props = {
  title: string
}

const Layout: React.FC<Props> = ({ children, title }) => {
  return (
    <div className="flex justify-center items-center flex-col min-h-screen text-white font-mono bg-gray-100">
      <Head>
        <title>{title}</title>
      </Head>
      <main className="flex flex-1 justify-center items-center w-screen flex-col">
        <SideMenu />
        {children}
      </main>
      <footer className="w-full h-6 flex justify-center items-center text-gray-500 text-sm">
        @Udemy 2021
      </footer>
    </div>
  )
}

export default Layout
