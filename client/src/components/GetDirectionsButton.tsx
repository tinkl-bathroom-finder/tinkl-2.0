import { Button } from "@mui/material";
import React from "react";

interface GetDirectionsButtonProps {
    address: string;
}

export const GetDirectionsButton: React.FC<GetDirectionsButtonProps> = ({ address }) => {
    const openMap = () => {
        const formattedAddress = encodeURIComponent(address);
        const mapURL = `https://www.google.com/maps/dir/?api=1&destination=${formattedAddress}`;

        window.open(mapURL, '_blank');
    };

    return (
        <Button size="small" onClick={openMap} variant="outlined" sx={{display: 'inline'}}>Get directions</Button>
    )
}
