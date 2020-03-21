import * as React from "react"

export default function List() {
    return (
        <div className="container">
            <div className="title">
                <span>weak: 345678</span>
                <span>medium: 100</span>
                <span>know: 100</span>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>word</th>
                        <th>My Answer.</th>
                        <th>status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th>1</th>
                        <th>spy</th>
                        <th>man</th>
                        <th>weak</th>
                    </tr>
                </tbody>
            </table>
        </div>
    )
}
