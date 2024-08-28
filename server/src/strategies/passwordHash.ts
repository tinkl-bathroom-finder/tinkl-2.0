import bcrypt from 'bcryptjs';

export const passwordHash = async (plainPassword: string): Promise<string> => {
    try {
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(plainPassword, salt);
        return hashedPassword;
    } catch (error) {
        throw new Error('Error hashing password');
    }
}