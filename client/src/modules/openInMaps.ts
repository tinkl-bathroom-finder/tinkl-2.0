export const openInMaps = (address: string) => {
    const formattedAddress = encodeURIComponent(address);
    const mapURL = `https://www.google.com/maps/search/?api=1&query=${formattedAddress}`;

    window.open(mapURL, '_blank');
};