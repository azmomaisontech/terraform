import { Link, Outlet } from "react-router";

export function App() {
    return (
        <div className="flex h-screen">
            <aside className="w-64 bg-gray-800 text-white flex flex-col p-4">
                <h1 className="text-xl font-bold mb-6">One Console</h1>
                <nav className="space-y-2">
                    <Link to="/" className="block px-3 py-2 rounded hover:bg-gray-700">Home</Link>
                    <Link to="/phone-numbers" className="block px-3 py-2 rounded hover:bg-gray-700">Phone Numbers</Link>
                </nav>
            </aside>

            <div className="flex-1 flex flex-col">
                <header className="bg-white shadow p-4 flex justify-between items-center">
                    <button
                        className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition duration-300 ease-in-out ml-auto"
                    >
                        Logout
                    </button>
                </header>

                <main className="flex-1 p-6 bg-gray-100 overflow-auto">
                    <Outlet/>
                </main>
            </div>
        </div>
    );
}

export default App;
