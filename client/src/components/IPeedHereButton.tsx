import { Button } from "@mui/material";
import React from "react";

// interface IPeedHereButtonProps {
//     id: number;
// }

export const IPeedHereButton: React.FC = () => {
    const clickIPeedHere = () => {
        console.log('You clicked it!')
    };

    return (
        <Button size="small" variant="contained" onClick={clickIPeedHere}>I Peed Here!</Button>
    )
}