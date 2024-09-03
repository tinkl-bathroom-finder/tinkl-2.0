import { Button } from "@mui/material";
import React from "react";

interface OpenInMapsButtonProps {
    address: string;
}

export const OpenInMapsButton: React.FC<OpenInMapsButtonProps> = ({ address }) => {
    const openMap = () => {
        const formattedAddress = encodeURIComponent(address);
        const mapURL = `https://www.google.com/maps/search/?api=1&query=${formattedAddress}`;

        window.open(mapURL, '_blank');
    };

    return (
        <Button size="small" onClick={openMap}>Open in Maps</Button>
    )
}
